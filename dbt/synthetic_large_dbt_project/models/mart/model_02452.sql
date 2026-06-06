{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01998') }},
        {{ ref('model_01798') }},
        {{ ref('model_01730') }}
)
select id, 'model_02452' as name from sources
