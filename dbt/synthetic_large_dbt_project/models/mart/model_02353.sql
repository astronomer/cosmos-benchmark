{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01687') }},
        {{ ref('model_02206') }},
        {{ ref('model_02166') }}
)
select id, 'model_02353' as name from sources
