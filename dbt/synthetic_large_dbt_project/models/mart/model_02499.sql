{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02148') }},
        {{ ref('model_01583') }},
        {{ ref('model_01847') }}
)
select id, 'model_02499' as name from sources
