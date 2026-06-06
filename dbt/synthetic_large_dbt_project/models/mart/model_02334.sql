{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02165') }},
        {{ ref('model_01950') }},
        {{ ref('model_01938') }}
)
select id, 'model_02334' as name from sources
