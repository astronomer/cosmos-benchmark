{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01732') }},
        {{ ref('model_01745') }}
)
select id, 'model_02636' as name from sources
