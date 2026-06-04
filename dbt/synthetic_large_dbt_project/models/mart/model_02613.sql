{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02204') }},
        {{ ref('model_01739') }}
)
select id, 'model_02613' as name from sources
