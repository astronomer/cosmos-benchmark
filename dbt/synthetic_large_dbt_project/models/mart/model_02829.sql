{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01545') }},
        {{ ref('model_01791') }}
)
select id, 'model_02829' as name from sources
