{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02119') }},
        {{ ref('model_02113') }},
        {{ ref('model_02176') }}
)
select id, 'model_02718' as name from sources
