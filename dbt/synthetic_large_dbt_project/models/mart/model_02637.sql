{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02214') }},
        {{ ref('model_01730') }},
        {{ ref('model_01990') }}
)
select id, 'model_02637' as name from sources
