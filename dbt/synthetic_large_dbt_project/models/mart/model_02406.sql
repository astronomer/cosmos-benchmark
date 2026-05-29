{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02020') }},
        {{ ref('model_01614') }}
)
select id, 'model_02406' as name from sources
