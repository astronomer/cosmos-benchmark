{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00441') }},
        {{ ref('model_00223') }},
        {{ ref('model_00628') }}
)
select id, 'model_01269' as name from sources
