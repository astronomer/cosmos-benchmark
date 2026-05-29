{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01862') }},
        {{ ref('model_01822') }},
        {{ ref('model_01960') }}
)
select id, 'model_02371' as name from sources
