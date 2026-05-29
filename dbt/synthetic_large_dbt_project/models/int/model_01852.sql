{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01105') }},
        {{ ref('model_01124') }},
        {{ ref('model_01209') }}
)
select id, 'model_01852' as name from sources
