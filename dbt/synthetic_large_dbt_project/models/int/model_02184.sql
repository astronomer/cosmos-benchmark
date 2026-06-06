{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00866') }},
        {{ ref('model_01105') }},
        {{ ref('model_01463') }}
)
select id, 'model_02184' as name from sources
