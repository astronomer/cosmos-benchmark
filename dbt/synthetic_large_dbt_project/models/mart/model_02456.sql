{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02006') }},
        {{ ref('model_01726') }},
        {{ ref('model_02105') }}
)
select id, 'model_02456' as name from sources
