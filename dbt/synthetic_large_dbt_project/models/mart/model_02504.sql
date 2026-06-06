{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01681') }},
        {{ ref('model_01951') }},
        {{ ref('model_02223') }}
)
select id, 'model_02504' as name from sources
